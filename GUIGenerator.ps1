Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set location to the script's directory
Set-Location -Path $PSScriptRoot

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Create your own GUI"
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# Create and configure controls
$textbox1form1 = New-Object System.Windows.Forms.TextBox
$textbox1form1.Size = New-Object System.Drawing.Size(110,30)
$textbox1form1.Location = New-Object System.Drawing.Point(10,30)

$label1form1 = New-Object System.Windows.Forms.Label
$label1form1.Text = "What Language do you want to code your UI?"
$label1form1.AutoSize = $true
$label1form1.Location = New-Object System.Drawing.Point(10,15)

$button1form1 = New-Object System.Windows.Forms.Button
$button1form1.Text = "Write template"
$button1form1.Size = New-Object System.Drawing.Size(110,30)
$button1form1.Location = New-Object System.Drawing.Point(10,70)

$list1form1 = New-Object System.Windows.Forms.ListBox
$list1form1.Items.Add("Python")
$list1form1.Items.Add("HTML")
$list1form1.Size = New-Object System.Drawing.Size(110,100)
$list1form1.Location = New-Object System.Drawing.Point(125,30)

$output1form1 = New-Object System.Windows.Forms.RichTextBox
$output1form1.Location = New-Object System.Drawing.Point(250,10)
$output1form1.Size = New-Object System.Drawing.Size(225,225)
$output1form1.ReadOnly = $true

# Event handler for ListBox selection
$list1form1.Add_SelectedIndexChanged({
    $textbox1form1.Text = $list1form1.SelectedItem
    Write-Host "ListBox selection changed. TextBox updated: '$($textbox1form1.Text)'"
})

# Event handler for Write template button click
$button1form1.Add_Click({
    $selectedLanguage = $textbox1form1.Text.Trim()
    Write-Host "Write template button clicked with TextBox text: '$selectedLanguage'"
    
    switch ($selectedLanguage) {
        "Python" {
            $output1form1.Text = @"
import tkinter as tk

def say_hello():
    print('Hello, World!')

root = tk.Tk()
root.title('Sample Python UI')

button = tk.Button(root, text='Click Me', command=say_hello)
button.pack(pady=20)

root.mainloop()
"@
        }
        "HTML" {
            $output1form1.Text = @"
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Sample HTML UI</title>
</head>
<body>
    <button onclick='alert(\"Hello, World!\")'>Click Me</button>
</body>
</html>
"@
        }
        default {
            $output1form1.Text = "Not supported. Sorry. D:"
        }
    }
})

# Add controls to the form
$form.Controls.Add($output1form1)
$form.Controls.Add($textbox1form1)
$form.Controls.Add($button1form1)
$form.Controls.Add($label1form1)
$form.Controls.Add($list1form1)

# Define global variable to pass the form to plugins
$global:mainForm = $form

# Load and execute each plugin script in the plugins folder
if (Test-Path -Path ".\plugins") {
    $pluginFiles = Get-ChildItem -Path ".\plugins" -Filter "*.ps1"

    foreach ($pluginFile in $pluginFiles) {
        Write-Host "Loading plugin: $($pluginFile.FullName)"
        # Execute each plugin script
        . $pluginFile.FullName
    }
} else {
    Write-Output "Plugins folder not found."
}

# Show the form
$form.ShowDialog()
