# paperless-helpers - Batch-process Scans to Paperless Suitable PDFs

This repository contains a script with a collection of commands that help to
convert scans into ready-to-consume PDFs for
[paperless-ngx](https://docs.paperless-ngx.com/). It focusses on
batch-processing to support any number of input scans.

## Setting Up Regular Backups

Creating regular backups is essential to avoid losing all personal documents in
case of unforeseen events. This guide will help you set up a backup system
using the provided files.

### Step 1: Install the paperless-backup Script

1. Copy the script `paperless-backup` to `/usr/bin/` to make it globally
   accessible.
2. The script requires two inputs:

   - The path to Paperless' docker-compose.yml file.
   - A file containing the encryption credentials.

  When executed, it will export all of Paperless' state to a specified export
  folder.


### Step 2: Set Up the Backup Service

1. Open the `paperless-backup.service` file.
2. Update the `SetCredentialEncrypted` value to match the encryption credential
   specific to the device you are setting up.
3. Copy the updated `paperless-backup.service` file to `/etc/systemd/system/`.
4. Enable the service by running `systemctl enable paperless-backup.service`
5. Test the setup by manually triggering a backup with `systemctl start
   paperless-backup`

### Step 3: Schedule Backups with a Timer

1. Open the `paperless-backup.timer` file and adjust the schedule to meet your
   needs.
2. Copy the file to `/etc/systemd/system/`.
3. Enable the timer by running `systemctl enable paperless-backup.timer`
4. The timer will now automatically perform backups based on the configured
   schedule.
