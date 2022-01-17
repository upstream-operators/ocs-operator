/*
Copyright 2021 Red Hat OpenShift Container Storage.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	v1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/resource"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// StorageConsumerState represent a StorageConsumer's state
type StorageConsumerState string

const (
	// StorageConsumerStateReady represents Ready state of StorageConsumer
	StorageConsumerStateReady StorageConsumerState = "Ready"
	// StorageConsumerStateConfiguring represents Configuring state of StorageConsumer
	StorageConsumerStateConfiguring StorageConsumerState = "Configuring"
	// StorageConsumerStateDeleting represents Deleting state of StorageConsumer
	StorageConsumerStateDeleting StorageConsumerState = "Deleting"
	// StorageConsumerStateFailed represents Failed state of StorageConsumer
	StorageConsumerStateFailed StorageConsumerState = "Failed"
)

// StorageConsumerSpec defines the desired state of StorageConsumer
type StorageConsumerSpec struct {
	// Capacity is the total quota size allocated to a consumer.
	Capacity resource.Quantity `json:"capacity"`
}

// CephObjectsSpec hold details of created ceph objects required for external storage
type CephObjectsSpec struct {
	// BlockPoolName holds the name of created ceph block pool.
	BlockPoolName string `json:"blockPoolName,omitempty"`
	// CephUser holds the name of created ceph user.
	CephUser string `json:"cephUser,omitempty"`
}

// StorageConsumerStatus defines the observed state of StorageConsumer
type StorageConsumerStatus struct {
	// State describes the state of StorageConsumer
	State StorageConsumerState `json:"state,omitempty"`
	// GrantedCapacity holds granted capacity value for the consumer
	GrantedCapacity resource.Quantity `json:"grantedCapacity,omitempty"`
	// CephObjects provide details of ceph created objects required for external storage
	CephObjects CephObjectsSpec `json:"cephObjects,omitempty"`
	// ConnectionDetails holds the reference to secret containing external connection details
	ConnectionDetails *v1.SecretKeySelector `json:"connectionDetails,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// StorageConsumer is the Schema for the storageconsumers API
type StorageConsumer struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   StorageConsumerSpec   `json:"spec,omitempty"`
	Status StorageConsumerStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// StorageConsumerList contains a list of StorageConsumer
type StorageConsumerList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []StorageConsumer `json:"items"`
}

func init() {
	SchemeBuilder.Register(&StorageConsumer{}, &StorageConsumerList{})
}