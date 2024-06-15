return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        "neotest-jest",
        "neotest-vitest",
      },
    },
  },
}
