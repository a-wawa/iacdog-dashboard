import { theme as chakraTheme } from "@chakra-ui/react";
// @ts-ignore
import resolveConfig from "tailwindcss/resolveConfig";
import tailwindConfig from "../../tailwind.config";

const tailwind = resolveConfig(tailwindConfig);

chakraTheme.colors.blue = tailwind.theme.colors.blue;

export const theme = {
  ...chakraTheme,
  colors: {
    ...chakraTheme.colors,
    blue: {
      ...chakraTheme.colors.blue,
      50: chakraTheme.colors.gray[50],
      100: chakraTheme.colors.gray[100],
    },
    darkBlue: {
      ...chakraTheme.colors.blue,
      50: chakraTheme.colors.gray[50],
      500: chakraTheme.colors.blue[800],
      600: chakraTheme.colors.blue[700],
      700: chakraTheme.colors.blue[800],
      800: chakraTheme.colors.blue[900],
      900: chakraTheme.colors.blue[900],
    },
  },
};