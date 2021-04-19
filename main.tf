
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

# importing csv
locals {
  snap = csvdecode(file("${path.module}/snapshot.csv"))
}

data "vsphere_virtual_machine" "vm" {
  for_each      = toset(local.snap.*.vm)
  name          = each.value
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine_snapshot" "snap" {

  for_each = toset(local.snap.*.vm)

  virtual_machine_uuid = data.vsphere_virtual_machine.vm[each.value].id
  snapshot_name        = local.snap[index(local.snap.*.vm,each.value)].snapshotname
  description          = local.snap[index(local.snap.*.vm,each.value)].description
  memory               = lower(local.snap[index(local.snap.*.vm,each.value)].memory)
  quiesce              = lower(local.snap[index(local.snap.*.vm,each.value)].quiesce)
  remove_children      = lower(local.snap[index(local.snap.*.vm,each.value)].removechildren)
  consolidate          = lower(local.snap[index(local.snap.*.vm,each.value)].consolidate)
}

