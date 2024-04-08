import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";
import { StackConfig } from "./types";

// Get some provider-namespaced configuration values
const providerCfg = new pulumi.Config("gcp");
const gcpProject = providerCfg.require("project");
const gcpRegion = providerCfg.require("region");

const config = new pulumi.Config().requireObject<StackConfig>("gcp");
const { env } = config;
console.log(`===> config`, config);

// Enable the GCP API services 
const apis: gcp.projects.Service[] = [];
for (const service of config.servicesApis) {
  const api = new gcp.projects.Service(`api-${service}`, { service });
  apis.push(api);
}

// Create a new network
const vpcNetwork = new gcp.compute.Network(
  `${env}-vpc`,
  {
    name: `${env}-vpc`,
    autoCreateSubnetworks: false,
    description: `the core VPC for ${env} environment`,
  },
  { dependsOn: apis }
);

// Create a new subnet in the network created above
const subnet = new gcp.compute.Subnetwork(`${env}-subnet`, {
  name: `${env}-subnet`,
  ipCidrRange: config.vpcCidr,
  network: vpcNetwork.id,
  privateIpGoogleAccess: true,
});

// Create a new GKE cluster
const gkeCluster = new gcp.container.Cluster(`${env}-cluster`, {
  name: `${env}-cluster`,
  enableAutopilot: true,
  allowNetAdmin: true,
  location: gcpRegion,
  network: vpcNetwork.name,
  subnetwork: subnet.name,
  networkingMode: "VPC_NATIVE",
  releaseChannel: {
    channel: "STABLE",
  },
  nodePoolAutoConfig: {
    networkTags: { tags: [`${env}-node-pool`] },
  },
  
}, {dependsOn: apis});


// // Create a service account for the node pool
// const gkeNodepoolSa = new gcp.serviceaccount.Account(
//   "gke-nodepool-sa",
//   {
//     accountId: pulumi.interpolate`${gkeCluster.name}-np-1-sa`,
//     displayName: "Nodepool 1 Service Account",
//   },
//   { dependsOn: gkeCluster }
// );

// // Create a nodepool for the GKE cluster
// const gkeNodepool = new gcp.container.NodePool(
//   "gke-nodepool",
//   {
//     cluster: gkeCluster.id,
//     nodeCount: config.nodesPerZone,
//     nodeConfig: {
//       tags: ["${var.mosaic_env}-node-pool"],
//       oauthScopes: ["https://www.googleapis.com/auth/cloud-platform"],
//       serviceAccount: gkeNodepoolSa.email,
//     },
//   },
// );

// // Build a Kubeconfig for accessing the cluster
// const clusterKubeconfig = pulumi.interpolate`apiVersion: v1
// clusters:
// - cluster:
//     certificate-authority-data: ${gkeCluster.masterAuth.clusterCaCertificate}
//     server: https://${gkeCluster.endpoint}
//   name: ${gkeCluster.name}
// contexts:
// - context:
//     cluster: ${gkeCluster.name}
//     user: ${gkeCluster.name}
//   name: ${gkeCluster.name}
// current-context: ${gkeCluster.name}
// kind: Config
// preferences: {}
// users:
// - name: ${gkeCluster.name}
//   user:
//     exec:
//       apiVersion: client.authentication.k8s.io/v1beta1
//       command: gke-gcloud-auth-plugin
//       installHint: Install gke-gcloud-auth-plugin for use with kubectl by following
//         https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
//       provideClusterInfo: true
// `;

// Export some values for use elsewhere
export const networkName = vpcNetwork.name;
export const networkId = vpcNetwork.id;
export const clusterName = gkeCluster.name;
export const clusterId = gkeCluster.id;
// export const kubeconfig = clusterKubeconfig;
