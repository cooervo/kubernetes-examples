export type StackConfig = {
  env: 'prod' | 'dev';
  vpcCidr: string;
  nodesPerZone: number;
  servicesApis: string[];
}