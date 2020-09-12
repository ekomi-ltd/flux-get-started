{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Values.parentChart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Values.parentChart.Name .Values.nameOverride }}
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
{{- define "app.chart" -}}
{{- printf "%s-%s" .Values.parentChart.Name .Values.parentChart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Values.parentChart.AppVersion }}
app.kubernetes.io/version: {{ .Values.parentChart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "service.name" -}}
{{- printf "%v-service" .global.Values.parentChart.Name | trunc 55 }}
{{- end }}

{{- define "web.name" -}}
{{ printf "%v-web" .global.Values.parentChart.Name | trunc 59 }}
{{- end }}

{{- define "worker.name" -}}
{{ printf "%v-%v" .global.Values.parentChart.Name .current.name | trunc 56 }}-worker
{{- end }}

{{- define "cron.name" -}}
{{ printf "%v-%v" .global.Values.parentChart.Name .current.name | trunc 58 }}-cron
{{- end }}

{{- define "web.labels" -}}
helm.sh/chart: {{ include "app.chart" .global }}
{{ include "web.selectorLabels" . }}
app.kubernetes.io/version: {{ .global.Values.parentChart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .global.Release.Service }}
app.kubernetes.io/part-of: {{ .global.Values.parentChart.Name }}
{{- end }}

{{- define "web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "web.name" . }}
app.kubernetes.io/instance: {{ .global.Release.Name }}
app.kubernetes.io/component: web
{{- end }}


{{- define "worker.labels" -}}
helm.sh/chart: {{ include "app.chart" .global }}
{{ include "worker.selectorLabels" . }}
app.kubernetes.io/version: {{ .global.Values.parentChart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .global.Release.Service }}
app.kubernetes.io/part-of: {{ .global.Values.parentChart.Name }}
{{- end }}

{{- define "worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "worker.name" . }}
app.kubernetes.io/instance: {{ .global.Release.Name }}
app.kubernetes.io/component: worker
{{- end }}

{{- define "crons.labels" -}}
helm.sh/chart: {{ include "app.chart" .global }}
app.kubernetes.io/name: {{ include "cron.name" . }}
app.kubernetes.io/instance: {{ .global.Release.Name }}
app.kubernetes.io/version: {{ .global.Values.parentChart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .global.Release.Service }}
app.kubernetes.io/component: cron
app.kubernetes.io/part-of: {{ .global.Values.parentChart.Name }}
{{- end }}