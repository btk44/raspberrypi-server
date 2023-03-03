import subprocess
import time

# before you run the script following actions are recommended:
# run bluetoothctl scan on
# run bluetoothctl pair ADDRESS
# run bluetoothctl trust ADDRESS

PRIMARY_DEVICE_ADDRESS = 'F4:4E:FD:E3:50:55' # some speaker
SECONDARY_DEVICE_ADDRESS = 'AB:52:0D:45:1B:34' # some other speaker
MAX_ATTEMPTS = 12
SCAN_FILE = 'scan-result'

def run_command(command_sting):
    return subprocess.run(command_sting, shell=True, capture_output=True)

def command_output(output):
    return output.stdout.decode('utf-8')

def output_not_empty(output):
    return len(command_output(output)) > 0

def kill_scanner():
    run_command('bluetoothctl scan off')
    ps_output = run_command("ps -al | grep bluetoothctl | awk '{print $4}'")
    process_id = command_output(ps_output)
    print('killing process: ' + process_id)
    run_command('kill scanner process: ' + process_id)


def connect_to_device(device_address):
    print('looking for ' + device_address)
    scan_output = run_command('cat scan-result | grep '+ device_address)
    device_found = output_not_empty(scan_output)
    if device_found:
        print('device found! attempting connection...')
        connect_output = run_command('bluetoothctl connect ' + device_address + " | grep 'Connection successful'")
        device_connected = output_not_empty(connect_output)

    result = device_found and device_connected

    if result:
        kill_scanner()

    return result

## main

# open file to save
scan_result_file = open(SCAN_FILE, 'w')
# stdbuf - all buffering set to 0 to flush command output as fast as possible
subprocess.Popen('stdbuf -i0 -o0 -e0 bluetoothctl scan on', shell=True, stdout=scan_result_file)

attempt = 1
while attempt <= MAX_ATTEMPTS:
    print('looking for connections (try count ' + str(attempt) + '):')
    time.sleep(1)
    if connect_to_device(PRIMARY_DEVICE_ADDRESS) or connect_to_device(SECONDARY_DEVICE_ADDRESS):
        break

    attempt += 1

if attempt > MAX_ATTEMPTS:
    print('connection failed')
else:
    print('connection successful')
