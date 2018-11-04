#!/bin/sh


# Our staff Macs bind to AD using the serial number of the computer. When the user logs in for the first time, they are prompted to insert the Asset ID of the Mac. This Asset ID is also used as the computer name.
# The script we use to prompt and rename:


# Loop until valid input is entered or Cancel is pressed.
while :; do
    computerName=$(osascript -e 'Tell application "System Events" to display dialog "Please insert your Asset ID number and click Submit:" default answer "" buttons {"Submit"} with icon caution' -e 'text returned of result' 2>/dev/null)

    if (( $? ));
        then exit 1; fi  # Abort, if user pressed Cancel.

        computerName=$(echo -n "$computerName" | sed 's/^ *//' | sed 's/ *$//')  # Trim leading and trailing whitespace.

    if [[ -z "$computerName" ]]; then

        # The user left the Asset ID number blank
        osascript -e 'Tell application "System Events" to display alert "You must enter your Asset ID number. Please try again" as warning' >/dev/null

        # Continue loop to prompt again.

        else
            # Valid input: exit loop and continue.
            break
    fi
done

/usr/sbin/scutil --set ComputerName "${computerName}"
/usr/sbin/scutil --set LocalHostName "${computerName}"
/usr/sbin/scutil --set HostName "${computerName}"

dscacheutil -flushcache

echo "Computer name has been set..."
echo "<result>`scutil --get ComputerName`</result>"

exit 0
