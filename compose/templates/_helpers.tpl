{{- define "initial_cluster" }}
  {{- range until (.Values.pd.size | int) }}
    {{- if . -}}
      ,
    {{- end -}}
    pd{{ . }}=http://
    {{- if eq $.Values.networkMode "host" -}}
      127.0.0.1:{{add (add ($.Values.pd.port | int) 10000) . }}
    {{- else -}}
      pd{{ . }}:2380
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "pd_list" }}
  {{- range until (.Values.pd.size | int) }}
    {{- if . -}}
      ,
    {{- end -}}
    {{- if eq $.Values.networkMode "host" -}}
      127.0.0.1:{{ add ($.Values.pd.port | int) . }}
    {{- else -}}
      pd{{ . }}:2379
    {{- end -}}
  {{- end -}}
{{- end -}}
