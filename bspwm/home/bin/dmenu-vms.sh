#!/usr/bin/env bash
# vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
# -----------------------------------------------------------------------------
# dmenu-vms.sh
#	A dmenu wrapper for VirtualBox VMs, to make it much easier to launch VMs
#	without having to load up the VirtualBox GUI. Adapted from
#	http://www.commandlinefu.com/commands/view/8554/list-the-vms-in-virtualbox-and-start-them-using-dmenu
# -----------------------------------------------------------------------------
# Location: $HOME/bin/dmenu-vms.sh
# -----------------------------------------------------------------------------

# TODO switch to the VM if it already exists?
dmenu_output=""
vms="$(vboxmanage list vms)"
while IFS='\n' read vm
do
	uuid="$(echo $vm | cut -f3 -d\" | tr -d '{} ')"
	vm_info_output="$(VBoxManage showvminfo --machinereadable $uuid)"

	declare -A vm_info
	vm_name="$(echo "$vm_info_output" | grep "^name=" | cut -d'"' -f2)"
	vm_ostype="$(echo "$vm_info_output" | grep "^ostype=" | cut -d'"' -f2)"
	vm_state="$(echo "$vm_info_output" | grep "^VMState=" | cut -d'"' -f2)"
	case "$vm_state" in
		"running" )
			vm_state_out="* "
			;;
		* )
			vm_state_out="  "
			;;
	esac

	if [[ -n "$dmenu_output" ]];
	then
		dmenu_output+="\n"
	fi
	dmenu_output+="${vm_state_out}${vm_name} (${vm_ostype}, ${uuid})"
done <<< "$vms"

chosen_vm_uuid="$(echo -e "$dmenu_output" | dmenu -i -p "VM:" | cut -f2 -d, | tr -d ' )')"
[[ -n "$chosen_vm_uuid" ]] && vboxmanage startvm --type gui "$chosen_vm_uuid"
