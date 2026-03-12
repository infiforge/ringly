import typescript from "@rollup/plugin-typescript";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import terser from "@rollup/plugin-terser";

const production = !process.env.ROLLUP_WATCH;

export default [
  {
    input: "src/index.ts",
    output: [
      {
        file: "dist/callattribution-tracker.js",
        format: "umd",
        name: "CallAttributionTracker",
        sourcemap: true,
      },
      {
        file: "dist/callattribution-tracker.min.js",
        format: "umd",
        name: "CallAttributionTracker",
        plugins: [terser()],
        sourcemap: true,
      },
      {
        file: "dist/callattribution-tracker.esm.js",
        format: "es",
        sourcemap: true,
      },
    ],
    plugins: [
      resolve({ browser: true }),
      commonjs(),
      typescript({
        tsconfig: "./tsconfig.json",
        declaration: true,
        declarationDir: "dist",
      }),
    ],
  },
];
