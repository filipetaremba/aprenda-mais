/** @type {import('jest').Config} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  globalSetup: '<rootDir>/tests/global-setup.ts',
  setupFiles: ['<rootDir>/tests/env.ts'],
  testTimeout: 30000,
  maxWorkers: 1,
};
