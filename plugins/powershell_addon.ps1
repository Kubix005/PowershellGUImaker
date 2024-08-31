# Access the global form object
$form = $global:mainForm

# Ensure the form object is valid before modifying controls
if ($null -ne $form) {
    Write-Host "PowerShell Plugin is working"

    # Access the existing controls
    $listBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.ListBox] }
    $textBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.TextBox] }
    $richTextBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.RichTextBox] }
    $button = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] -and $_.Text -eq "Write template" }

    if ($listBox -ne $null -and $textBox -ne $null -and $richTextBox -ne $null -and $button -ne $null) {
        # Add "PowerShell" to the ListBox items if it's not already present
        if (-not $listBox.Items.Contains("PowerShell")) {
            $listBox.Items.Add("PowerShell")
            Write-Host "'PowerShell' added to ListBox"
        }

        # Define the logic for updating the RichTextBox based on the TextBox text
        $updateRichTextBox = {
            $textBoxText = $textBox.Text.Trim()
            switch ($textBoxText) {
                "PowerShell" {
                    $richTextBox.Text = @"
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Sample PowerShell UI'
$form.Size = New-Object System.Drawing.Size(300,200)

$button = New-Object System.Windows.Forms.Button
$button.Text = 'Click Me'
$button.Location = New-Object System.Drawing.Point(100,70)
$button.Add_Click({ 
    [System.Windows.Forms.MessageBox]::Show('Hello, World!') 
})

$form.Controls.Add($button)
$form.ShowDialog()
"@
                }
            }
        }

        # Register the event handler for TextBox text change
        $textBox.Add_TextChanged($updateRichTextBox)

        # Event handler for ListBox selection change
        $listBox.Add_SelectedIndexChanged({
            $selectedItem = $listBox.SelectedItem
            if ($selectedItem -eq "PowerShell") {
                $textBox.Text = $selectedItem
                # Manually call the update logic
                $updateRichTextBox.Invoke()
            }
        })

        # Event handler for Button click
        $button.Add_Click({
            $selectedItem = $listBox.SelectedItem
            $textBoxText = $textBox.Text

            if ($selectedItem -eq "PowerShell") {
                $textBox.Text = $selectedItem
                # Manually call the update logic
                $updateRichTextBox.Invoke()
            } else {
                $richTextBox.Text = "Not supported. Sorry. D:"
            }
        })
    } else {
        Write-Output "ListBox, TextBox, RichTextBox, or Write Template Button control not found."
    }
} else {
    Write-Output "Form object is null; cannot add controls."
}
