import { VZServerRes, VZClientData } from "@aww-vzc/types";
import { useQuery } from "react-query";
import axios, { AxiosRequestConfig } from 'axios'
import { VZServer2VZClientData } from "@aww-vzc/react";

export const fetcher = async <T = any, D = any>
  (config: AxiosRequestConfig<D>): Promise<T> => {

  // 400번대의 에러는 ./error에 정의된 에러 throw (현재 404, 403, 401만 정의)
  const res = (await axios.request(config));

  // 혹시나 백엔드에서 예외처리를 하지 못해 ResponseDto의 형태를 갖추지 못하고 발생하는 오류의 경우 
  if (!res.data.success === undefined) throw new Error(`unknown api error with error code ${res.status}`)

  const { error, success } = res.data;

  // 백엔드에서 예외처리를 하고, 에러가 발생한 경우
  if (!success) throw new Error(error.code + error.message)

  // 에러가 없는 경우!
  const { data } = res.data

  return data;
}

export const useVisualizerQuery = (file: File, hash: string, isLagacy?: boolean) => {

  return useQuery<VZClientData>(['visualizer', file.name, hash, isLagacy ? 'sanbo' : "new"], async () => {
    const res = await fetcher<VZServerRes>({
      url: `${isLagacy ? process.env.NEXT_PUBLIC_LEGACY_VISUALIZER_SERVER_PATH :
        process.env.NEXT_PUBLIC_VISUALIZER_SERVER_PATH}`, method: 'post',
      data: { file: file },
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });

    const icData = VZServer2VZClientData(res)

    return icData;
  });
}
