import { AWWProvider, configureAWWStore } from "@aww-vzc/react";

const store = configureAWWStore({
  initialState: {
    config: {
      dev: {
        iconBasePath: process.env.NEXT_PUBLIC_ICON_BASE_PATH,
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

export function WithProvider({ children }: { children: React.ReactNode }) {
  return <AWWProvider store={store}>{children}</AWWProvider>;
}
