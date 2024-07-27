return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "adrigzr/neotest-mocha",
      "marilari88/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        "neotest-mocha",
        "neotest-jest",
        "neotest-vitest",
      },
    },
  },
}
