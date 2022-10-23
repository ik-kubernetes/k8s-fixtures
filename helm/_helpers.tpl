{{/*
Return the appropriate apiVersion for CSIDriver.
*/}}
{{- define "csidriver.apiVersion" -}}
{{- if semverCompare ">=1.18-0" .Capabilities.KubeVersion.Version }}
{{- print "storage.k8s.io/v1" -}}
{{- else -}}
{{- print "storage.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for CSIDriver.
*/}}
{{- define "csidriver.apiVersion" -}}
{{- if and .Values.rbac.pspEnabled (.Capabilities.APIVersions.Has "policy/v1beta1/PodSecurityPolicy") }}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
