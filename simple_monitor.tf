provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
}

resource "datadog_monitor" "foo" {
  name               = "Terraform example"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @hipchat-channel"
  escalation_message = "Escalation message @pagerduty"

  query = "avg(last_1h):avg:aws.ec2.cpu{environment:foo,host:foo} by {host} > 4"

  thresholds = {
    ok                = 0
    warning           = 2
    warning_recovery  = 1
    critical          = 4
    critical_recovery = 3
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  # ignore any changes in silenced value; using silenced is deprecated in favor of downtimes
  lifecycle {
    ignore_changes = [silenced]
  }

  tags = ["created_by:terraform", "version:1.0","owner:jacky"]
}

variable "datadog_api_key" {}
variable "datadog_app_key" {}
