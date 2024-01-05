import { MetadataRoute } from 'next'

const BASE_PATH = process.env.NEXT_PUBLIC_DOMAIN || ""

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: `${BASE_PATH}`,
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 1,
    },
    {
      url: `${BASE_PATH}/visualizer`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    }
  ]
}