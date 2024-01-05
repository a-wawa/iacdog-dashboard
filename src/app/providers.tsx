"use client";
import { CacheProvider } from "@chakra-ui/next-js";
import { ChakraProvider, extendTheme } from "@chakra-ui/react";
import { QueryClientProvider, QueryClient } from "react-query";
import { AWWProvider, configureAWWStore } from "@aww-vzc/react";

const theme = extendTheme({
  colors: {
    primary: {
      main: "#ea580c",
      50: "#fff7ed",
      100: "#ffedd5",
      200: "#fed7aa",
      300: "#fdba74",
      400: "#fb923c",
      500: "#f97316",
      600: "#ea580c",
      700: "#c2410c",
      800: "#9a3412",
      900: "#7c2d12",
    },
  },
});

const store = configureAWWStore({
  initialState: {
    config: {
      dev: {
        iconBasePath: process.env.NEXT_PUBLIC_BASE_PATH,
        isDev: false,
      },
      view: {
        sidebar: {
          disable: false,
        },
      },
    },
  },
  devTools: process.env.NODE_ENV !== "production",
});
const queryClient = new QueryClient();

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <CacheProvider>
      <ChakraProvider>
        <QueryClientProvider client={queryClient}>
          <AWWProvider store={store}>{children}</AWWProvider>
        </QueryClientProvider>
      </ChakraProvider>
    </CacheProvider>
  );
}
