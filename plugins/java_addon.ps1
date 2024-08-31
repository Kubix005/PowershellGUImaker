# Access the global form object
$form = $global:mainForm

# Ensure the form object is valid before modifying controls
if ($null -ne $form) {
    Write-Host "Java Plugin is working"

    # Access the existing controls
    $listBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.ListBox] }
    $textBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.TextBox] }
    $richTextBox = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.RichTextBox] }
    $button = $form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] -and $_.Text -eq "Write template" }

    if ($listBox -ne $null -and $textBox -ne $null -and $richTextBox -ne $null -and $button -ne $null) {
        # Add "Java" to the ListBox items if it's not already present
        if (-not $listBox.Items.Contains("Java")) {
            $listBox.Items.Add("Java")
            Write-Host "'Java' added to ListBox"
        }

        # Define the logic for updating the RichTextBox based on the TextBox text
        $updateRichTextBox = {
            $textBoxText = $textBox.Text.Trim()
            switch ($textBoxText) {
                "Java" {
                    $richTextBox.Text = @"
import javax.swing.*;

public class SampleJavaUI {
    public static void main(String[] args) {
        JFrame frame = new JFrame('Sample Java UI');
        JButton button = new JButton('Click Me');
        button.addActionListener(e -> JOptionPane.showMessageDialog(frame, 'Hello, World!'));
        frame.add(button);
        frame.setSize(300, 200);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}
"@
                }
            }
        }

        # Register the event handler for TextBox text change
        $textBox.Add_TextChanged($updateRichTextBox)

        # Event handler for ListBox selection change
        $listBox.Add_SelectedIndexChanged({
            $selectedItem = $listBox.SelectedItem
            if ($selectedItem -eq "Java") {
                $textBox.Text = $selectedItem
                # Manually call the update logic
                $updateRichTextBox.Invoke()
            }
        })

        # Event handler for Button click
        $button.Add_Click({
            $selectedItem = $listBox.SelectedItem

            if ($selectedItem -eq "Java") {
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
