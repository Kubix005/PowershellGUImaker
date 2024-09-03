# Access the global form object
$form = $global:mainForm

# Ensure the form object is valid before modifying controls
if ($null -ne $form) {
    Write-Host "C# Plugin is working"

    # Access the existing controls
    $listBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.ListBox] }
    $textBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.TextBox] }
    $richTextBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.RichTextBox] }
    $button = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] -and $_.Text -eq "Write template" }

    if ($null -ne $listBox -and $null -ne $textBox -and $null -ne $richTextBox -and $null -ne $button) {
        # Add "C#" to the ListBox items if it's not already present
        if (-not $listBox.Items.Contains("C#")) {
            $listBox.Items.Add("C#")
            Write-Host "'C#' added to ListBox"
        }

        # Define the logic for updating the RichTextBox based on the TextBox text
        $updateRichTextBox = {
            $textBoxText = $textBox.Text.Trim()
            switch ($textBoxText) {
                "Python" {
                    $richTextBox.Text = @"
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
                    $richTextBox.Text = @"
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
                "C#" {
                    $richTextBox.Text = @"
using System;
using System.Windows.Forms;

namespace SampleCSharpUI
{
    public class Program : Form
    {
        public Program()
        {
            Text = \"Sample C# UI\";
            Button button = new Button();
            button.Text = \"Click Me\";
            button.Click += (sender, e) => MessageBox.Show(\"Hello, World!\");
            Controls.Add(button);
            button.Dock = DockStyle.Fill;
        }

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Program());
        }
    }
}
"@
                }
                default {
                    $richTextBox.Text = "Not supported. Sorry. D:"
                }
            }
        }

        # Register the event handler for TextBox text change
        $textBox.Add_TextChanged($updateRichTextBox)

        # Event handler for ListBox selection change
        $listBox.Add_SelectedIndexChanged({
            $selectedItem = $listBox.SelectedItem
            if ($selectedItem -eq "Python" -or $selectedItem -eq "HTML" -or $selectedItem -eq "C#") {
                $textBox.Text = $selectedItem
                # Manually call the update logic
                $updateRichTextBox.Invoke()
            }
        })

        # Event handler for Button click
        $button.Add_Click({
            $selectedItem = $listBox.SelectedItem

            if ($selectedItem -eq "Python" -or $selectedItem -eq "HTML" -or $selectedItem -eq "C#") {
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
