Add-Type -AssemblyName PresentationFramework

#Path
$xamlFile="C:\Users\marcu\source\repos\Toolbox\Toolbox\MainWindow.xaml"

$inputXAML=Get-Content -Path $xamlFile -Raw
$inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'
[XML]$XAML=$inputXAML

$reader = New-Object System.Xml.XmlNodeReader $XAML
try{
    $psform=[Windows.MarkUp.XamlReader]::Load($reader)
}catch{
    Write-Host $_.Exception
    throw
}

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    try{
        Set-Variable -Name "var_$($_.Name)" -Value $psform.FindName($_.Name) -ErrorAction Stop
    }catch{
        throw
    }
}

Get-Variable var_*

Get-Service | ForEach-Object {$var_ddlServices.Items.Add($_.Name)}

#Funktsioonid
function GetDetails{
    $ServiceName=$var_ddlServices.SelectedItem
    $details=Get-Service -Name $ServiceName | Select *
    $var_lblName.Content=$details.name
    $var_lblStatus.Content=$details.status

    if($var_lblStatus.Content -eq 'Running'){
        $var_lblStatus.Foreground='green'
    }else{
        $var_lblStatus.Foreground='red'
    }
}

##Buttonite functionid
###Button1=Shutdown
$var_btn1.Add_Click({
    Stop-Computer -Force
    })

###Button2=Restart
$var_btn2.Add_Click({
    Restart-Computer -Force
    })

###URL DEFINITSIOONID
$urlYoutube  ='https://www.youtube.com'
$urlRespitory='https://github.com/marcus442/Harjutamine'
$urlOffice='https://www.office.com'
$urlReddit='https://www.reddit.com'
$urlDrive='https://drive.google.com/drive/home'

###Button3=Chrome Youtube
$var_btn3.Add_Click({
    Start-Process 'chrome.exe' -ArgumentList $urlYoutube
    $var_textbox.Text = $urlYoutube.ToString()
    }) 

###Button4=Aeg
$var_btn4.Add_Click({
    $CurrentDate = Get-Date
    $CurrentDate
    $var_textbox.Text = $currentDate.ToString()
    })

###Button5=Chrome GitHubi Respitory
$var_btn5.Add_Click({
    Start-Process 'chrome.exe' -ArgumentList $urlRespitory
    $var_textbox.Text = $urlRespitory.ToString()
    }) 

###Button6=Drive
$var_btn6.Add_Click({
    Start-Process 'chrome.exe' -ArgumentList $urlDrive
    $var_textbox.Text = $urlDrive.ToString()
    }) 

###Button7=Office.com
$var_btn7.Add_Click({
    Start-Process 'chrome.exe' -ArgumentList $urlOffice
    $var_textbox.Text = $urlOffice.ToString()
    }) 

###Button9=Reddit
$var_btn9.Add_Click({
    Start-Process 'chrome.exe' -ArgumentList $urlReddit
    $var_textbox.Text = $urlReddit.ToString()
    }) 

###Button10=Exit
$var_btn10.Add_Click({
    $psform.Close()
    })


##Checkboxide funktsioonid
###Checkbox1=Darkmode
$var_checkbox1.Add_Checked({
    if ($var_checkbox1.Checked) {
        $var_Grid1.Background=[System.Windows.Media.Brushes]::DimGray
    } else {
        $var_Grid1.Background=[System.Windows.Media.Brushes]::DarkSlateGray
    }
    })
###Uncheck
$var_checkbox1.Add_Unchecked({
    if ($var_checkbox1.Unchecked) {
        $var_Grid1.Background=[System.Windows.Media.Brushes]::AliceBlue
    } else {
        $var_Grid1.Background=[System.Windows.Media.Brushes]::NavajoWhite
    }
    })

        

###Tabbide functionid

$var_ddlServices.Add_SelectionChanged({GetDetails})


$psform.ShowDialog()
#FF3A2525 FFE5E5E5