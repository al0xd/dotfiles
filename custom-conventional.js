module.exports = {
  types: [
    { type: "feat", section: "Features", hidden: false },
    { type: "fix", section: "Bug Fixes", hidden: false },
    { type: "perf", section: "Performance Improvements", hidden: false },
    { type: "chore", section: "Chores", hidden: true },
    { type: "docs", section: "Documentation", hidden: false },
    { type: "style", section: "Styling", hidden: false },
    { type: "refactor", section: "Refactoring", hidden: false },
    { type: "test", section: "Tests", hidden: false },
    { type: "build", section: "Build System", hidden: false },
    { type: "ci", section: "Continuous Integration", hidden: false },
    { type: "/^FC-\\d+$/", section: "Feature Changes", hidden: false }
  ]
};
