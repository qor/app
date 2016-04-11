package ios_ec

import (	
    "fmt"
    "os"
    "bytes"
    "bufio"
    "strings"
    "regexp"
    "os/exec"
    "io/ioutil"
    "encoding/json"
    "github.com/qor/app"
)

type EC struct {
	Proj_name string
	app.Theme
	Path string
}

func (ec *EC) GetTemplatesPath() string {
	if ec.TemplatesPath == "" {
		ec.TemplatesPath = "github.com/qor/app/ios_ec/templates"
	}
	return ec.Theme.GetTemplatesPath()
}

func (ec *EC) ConfigureQorTheme(theme app.ThemeInterface) {
	ec.Theme.Path = ec.Path
	return
}

func JSONMarshal(v interface{}, unescape bool) ([]byte, error) {
    b, err := json.MarshalIndent(v, "", "    ") 

    if unescape {
        b = bytes.Replace(b, []byte("\\u003c"), []byte("<"), -1)
        b = bytes.Replace(b, []byte("\\u003e"), []byte(">"), -1)
        b = bytes.Replace(b, []byte("\\u0026"), []byte("&"), -1)
    }
    return b, err
}

func checkError(err error) {
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(0)
	}
}

func configProj(name string) {
	content, err := ioutil.ReadFile("temp.gyp")
   	checkError(err)

    var conf map[string]interface{}
    err=json.Unmarshal(content, &conf)
   	checkError(err)

    conf["targets"].([]interface{})[0].(map[string]interface{})["target_name"] = name

    b, err := JSONMarshal(conf, true) 
   	checkError(err)

    err = ioutil.WriteFile(fmt.Sprintf("%s.gyp", name), b, 0644)
   	checkError(err)

   	// delete temp file
	err = os.Remove("temp.gyp")
	checkError(err)
}

func configMakefile(name string) {
	file, err := os.Open("Makefile")
    checkError(err)
    defer file.Close()

    scanner := bufio.NewScanner(file)
    lines := []string{}
    
    count := 0
    for scanner.Scan() {
    	if count == 3 {
    		lines = append(lines, fmt.Sprintf("	gyp %s.gyp --depth=. -f xcode -DOS=ios", name))
    	} else if count == 4 {
    		lines = append(lines, fmt.Sprintf("	ruby scripts/fix-project.rb %s.xcodeproj", name))
    	} else {
    		lines = append(lines, scanner.Text())
    	}
        count++
    }
    
    if err := scanner.Err(); err != nil {
        checkError(err)
    }

	ioutil.WriteFile("Makefile", []byte(strings.Join(lines, "\n")), 0644)	
    checkError(err)
}

func configPodfile(name string) {
	file, err := os.Open("Podfile")
    checkError(err)
    defer file.Close()

    scanner := bufio.NewScanner(file)
    lines := []string{}
    
    count := 0
    for scanner.Scan() {
    	if count == 0 {
    		lines = append(lines, fmt.Sprintf("target '%s' do", name))
    	} else {
    		lines = append(lines, scanner.Text())
    	}
        count++
    }
    
    if err := scanner.Err(); err != nil {
        checkError(err)
    }

	ioutil.WriteFile("Podfile", []byte(strings.Join(lines, "\n")), 0644)	
    checkError(err)
}

func getIPhone5sHash() string {
    var (
        cmdOut []byte
        errSH    error
    )
    cmdName := "instruments"
    cmdArgs := []string{"-s", "devices"}
    if cmdOut, errSH = exec.Command(cmdName, cmdArgs...).Output(); errSH != nil {
        return ""
    }

    result := strings.Split(string(cmdOut), "\n")
    iphone5sArr := []string{}
    for _,v :=range result {
        if strings.HasPrefix(strings.TrimSpace(v), "iPhone 5s") {
            iphone5sArr = append(iphone5sArr, v)
        }
    }
    iphone5sHash := ""
    if len(iphone5sArr) > 0 {
        iphone5sHash = iphone5sArr[len(iphone5sArr)-1]
        re := regexp.MustCompile(`\[([^\[\]]*)\]`)
        result = re.FindStringSubmatch(iphone5sHash)
        iphone5sHash = result[len(result)-1]
    } 
    return iphone5sHash
}

func configRunShell(name string) {
	file, err := os.Open("runSimulator.sh")
    checkError(err)
    defer file.Close()

    scanner := bufio.NewScanner(file)
    lines := []string{}
    
    count := 0
    for scanner.Scan() {
    	if count == 8 {
    		lines = append(lines, fmt.Sprintf("xcodebuild -scheme %s -workspace %s.xcworkspace -destination 'platform=iphonesimulator,name=iPhone 5s' -derivedDataPath build", name, name))
    	} else if count == 11 {
    		lines = append(lines, fmt.Sprintf("xcrun simctl uninstall booted \"%s\"", name))
    	} else if count == 12 {
    		lines = append(lines, fmt.Sprintf("xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/%s.app", name))
    	} else if count == 15 {
    		lines = append(lines, fmt.Sprintf("xcrun simctl launch booted \"%s\"", name))
    	} else if count == 5 {
            if len(getIPhone5sHash()) > 0 {
                lines = append(lines, fmt.Sprintf("xcrun instruments -w '%s'", getIPhone5sHash()))
            } else {
                fmt.Println("There was an error running instruments -s devices command")
            }
        } else {
    		lines = append(lines, scanner.Text())
    	}
        count++
    }
    
    if err := scanner.Err(); err != nil {
        checkError(err)
    }

	ioutil.WriteFile("runSimulator.sh", []byte(strings.Join(lines, "\n")), 0644)	
    checkError(err)
}

func (ec *EC) Build(theme app.ThemeInterface) error {
	pwd, _ := os.Getwd() 
	os.Chdir("iOS/Temp")

	// config .gyp file
	configProj(ec.Proj_name)

	// config make file
	configMakefile(ec.Proj_name)

	// config pod file
	configPodfile(ec.Proj_name)

	// config run bash file
	configRunShell(ec.Proj_name)

	// generate Xcode project, install third-party libs and so on...
	exec.Command("make","all").Run()

	os.Chdir(pwd)
    exec.Command("mv", "iOS/Temp", fmt.Sprintf("iOS/%s", ec.Proj_name)).Run()
    
	return nil
}
