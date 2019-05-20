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

{{- define "pd_urls" }}
  {{- range until (.Values.pd.size | int) }}
    {{- if . -}}
      ,
    {{- end -}}
    {{- if eq $.Values.networkMode "host" -}}
      http://127.0.0.1:{{ add ($.Values.pd.port | int) . }}
    {{- else -}}
      http://pd{{ . }}:2379
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "zoo_servers" }}
  {{- range until (.Values.zookeeper.size | int) }}
    {{- if eq $.Values.networkMode "host" -}}
      {{- if . }} {{ end }}server.{{ add . 1 }}=127.0.0.1:{{ add . 2888 }}:{{ add . 3888 }}
    {{- else -}}
      {{- if . }} {{ end }}server.{{ add . 1 }}=zoo{{ . }}:2888:3888
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "zoo_connect" }}
  {{- range until (.Values.zookeeper.size | int) }}
    {{- if . -}}
      ,
    {{- end -}}
    {{- if eq $.Values.networkMode "host" -}}
      127.0.0.1:{{ add $.Values.zookeeper.port . }}
    {{- else -}}
      zoo{{ add . }}:{{ add $.Values.zookeeper.port . }}
    {{- end -}}
  {{- end -}}
{{- end -}}
