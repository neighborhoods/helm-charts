{{/*
Default name for HTTP service
*/}}
{{- define "standard-app.v1.default-service-name" -}}
{{- include "util.v1.autoname" . | trunc 58 | trimSuffix "-" }}-http
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart.labels" -}}
helm.sh/chart: {{ include "chart.chart" . }}
{{ include "chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Default name for nginx config map
*/}}
{{- define "standard-app.v1.default-nginx-configmap-name" -}}
{{- include "util.v1.autoname" . }}-http-nginx-config
{{- end -}}

{{/*
Default name for nginx basic auth config map
*/}}
{{- define "standard-app.v1.default-nginx-auth-configmap-name" -}}
{{- include "util.v1.autoname" . }}-http-nginx-auth-config
{{- end -}}

{{/*
Base labels for resources
*/}}
{{ define "standard-app.v1.resource-labels" }}
{{ include "standard-app.v1.selector-labels" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
heritage: {{ .Release.Service }}
{{ end }}

{{/*
Base labels for selectors
*/}}
{{ define "standard-app.v1.selector-labels" }}
app: {{ .Values.appName | required "Must specify .Values.appName"  | quote }}
release: {{ .Release.Name }}
{{ end }}

{{/*
All the possible probes
*/}}
{{ define "standard-app.v1.readiness-probe" }}
{{ with . }}
readinessProbe:
{{ toYaml . | indent 2 }}
{{ end }}
{{ end }}

{{ define "standard-app.v1.liveness-probe" }}
{{ with . }}
livenessProbe:
{{ toYaml . | indent 2 }}
{{ end }}
{{ end }}

{{ define "standard-app.v1.startup-probe" }}
{{ with . }}
startupProbe:
{{ toYaml . | indent 2 }}
{{ end }}
{{ end }}
