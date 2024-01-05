import { create } from 'zustand'

interface AWWDashboardState {
  file: File | null
  fileString: string | null
  isLagacy: boolean;
  setFile: (file: File | null) => void
  setFileString: (fileString: string | null) => void
  setIsLagacy: (isLagacy: boolean) => void
}

const useAWWStore = create<AWWDashboardState>((set) => ({
  file: null,
  fileString: null,
  isLagacy: false,
  setFile: (file: File | null) => set((state) => ({ ...state, file })),
  setFileString: (fileString: string | null) => set((state) => ({ ...state, fileString })),
  setIsLagacy: (isLagacy: boolean) => set((state) => ({ ...state, isLagacy }))
}));

export default useAWWStore