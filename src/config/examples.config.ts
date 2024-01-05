const BASE = 'public/example/terraform'

export type CodeSampleData = Record<'src' | 'filename' | 'csp', string>

export const codeSampleCategory = ['aws', 'ncp', 'multi'] as const
export type CodeSampleCategory = typeof codeSampleCategory[number]

const aws: CodeSampleData[] = [
  // { csp: "aws", src: `${BASE}/aws-attachment.tf`, filename: 'aws-attachment.tf' },
  // { csp: "aws", src: `${BASE}/aws-ec2.tf`, filename: 'aws-ec2.tf' },
  // { csp: "aws", src: `${BASE}/aws-instance.tf`, filename: 'aws-instance.tf' },
  // { csp: "aws", src: `${BASE}/aws-provider.tf`, filename: 'aws-provider.tf' },
  // { csp: "aws", src: `${BASE}/aws-region.tf`, filename: 'aws-region.tf' },
  // { csp: "aws", src: `${BASE}/aws.tf`, filename: 'aws.tf' },
  // { csp: "aws", src: `${BASE}/aws2.tf`, filename: 'aws2.tf' },
  // { csp: "aws", src: `${BASE}/aws3.tf`, filename: 'aws3.tf' },
  // { csp: "aws", src: `${BASE}/aws-big.tf`, filename: 'aws-big.tf' },
  // { csp: "aws", src: `${BASE}/aws-big2.tf`, filename: 'aws-big2.tf' },
  { csp: "aws", src: `${BASE}/aws_2tier.tf`, filename: 'aws_2tier.tf' },
  { csp: "aws", src: `${BASE}/aws_region.tf`, filename: 'aws_region.tf' },
  { csp: "aws", src: `${BASE}/aws_s3.tf`, filename: 'aws_s3.tf' },
]
const ncp: CodeSampleData[] = [
  // { csp: "ncp", src: `${BASE}/ncp.tf`, filename: 'ncp.tf' },
  // { csp: "ncp", src: `${BASE}/ncp2.tf`, filename: 'ncp2.tf' },
  // { csp: "ncp", src: `${BASE}/ncp3.tf`, filename: 'ncp3.tf' },
  // { csp: "ncp", src: `${BASE}/ncp4.tf`, filename: 'ncp4.tf' },
  // { csp: "ncp", src: `${BASE}/ncp5.tf`, filename: 'ncp5.tf' },
  { csp: "ncp", src: `${BASE}/ncloud_vpc.tf`, filename: 'ncloud_vpc.tf' },
]

const multi: CodeSampleData[] = [
  // { csp: "multi", src: `${BASE}/multi.tf`, filename: 'multi.tf' },
  { csp: "multi", src: `${BASE}/multi_cloud.tf`, filename: 'multi_cloud.tf' },
]

export const terraformExamples = [
  ...aws, ...ncp, ...multi
]

