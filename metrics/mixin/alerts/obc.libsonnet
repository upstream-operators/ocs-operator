{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'odf-obc-quota-alert.rules',
        rules: [
          {
            alert: 'ObcQuotaBytesAlert',
            expr: |||
              (ocs_objectbucketclaim_info * on (namespace, objectbucket, managedBy) group_left() (ocs_objectbucket_used_bytes/ocs_objectbucket_max_bytes)) > 0.80
            ||| % $._config,
            'for': $._config.odfObcQuotaAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'OBC has crossed 80% of the quota(bytes) in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}.',
              description: 'ObjectBucketClaim {{ $labels.objectbucketclaim }} has crossed 80% of the size limit set by the quota(bytes) and will become read-only on reaching the quota limit in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}. Increase the quota in the {{ $labels.objectbucketclaim }} OBC custom resource.',
              storage_type: $._config.objectStorageType,
              severity_level: 'warning',
              runbook_url: 'https://github.com/openshift/runbooks/blob/master/alerts/openshift-container-storage-operator/ObcQuotaBytesAlert.md',
            },
          },
          {
            alert: 'ObcQuotaObjectsAlert',
            expr: |||
              (ocs_objectbucketclaim_info * on (namespace, managedBy, objectbucket) group_left() (ocs_objectbucket_objects_total/ocs_objectbucket_max_objects)) > 0.80
            ||| % $._config,
            'for': $._config.odfObcQuotaAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'OBC has crossed 80% of the quota(object) in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}.',
              runbook_url: 'https://github.com/openshift/runbooks/blob/master/alerts/openshift-container-storage-operator/ObcQuotaObjectsAlert.md',
              description: 'ObjectBucketClaim {{ $labels.objectbucketclaim }} has crossed 80% of the size limit set by the quota(objects) and will become read-only on reaching the quota limit in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}. Increase the quota in the {{ $labels.objectbucketclaim }} OBC custom resource.',
              storage_type: $._config.objectStorageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'ObcQuotaBytesExhausedAlert',
            expr: |||
              (ocs_objectbucketclaim_info * on (namespace, managedBy, objectbucket) group_left() (ocs_objectbucket_used_bytes/ocs_objectbucket_max_bytes)) >= 1
            ||| % $._config,
            'for': $._config.odfObcQuotaCriticalAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'OBC reached quota(bytes) limit in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}.',
              runbook_url: 'https://github.com/openshift/runbooks/blob/master/alerts/openshift-container-storage-operator/ObcQuotaBytesExhausedAlert.md',
              description: 'ObjectBucketClaim {{ $labels.objectbucketclaim }} has crossed the limit set by the quota(bytes) and will be read-only now in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}. Increase the quota in the {{ $labels.objectbucketclaim }} OBC custom resource immediately.',
              storage_type: $._config.objectStorageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'ObcQuotaObjectsExhausedAlert',
            expr: |||
              (ocs_objectbucketclaim_info * on (namespace, managedBy, objectbucket) group_left() (ocs_objectbucket_objects_total/ocs_objectbucket_max_objects)) >= 1
            ||| % $._config,
            'for': $._config.odfObcQuotaCriticalAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'OBC reached quota(object) limit in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}.',
              runbook_url: 'https://github.com/openshift/runbooks/blob/master/alerts/openshift-container-storage-operator/ObcQuotaObjectsExhausedAlert.md',
              description: 'ObjectBucketClaim {{ $labels.objectbucketclaim }} has crossed the limit set by the quota(objects) and will be read-only now in namespace:cluster {{ $labels.namespace }}:{{ $labels.managedBy }}. Increase the quota in the {{ $labels.objectbucketclaim }} OBC custom resource immediately.',
              storage_type: $._config.objectStorageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
