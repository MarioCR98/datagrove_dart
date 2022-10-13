export {};

declare global {
  interface Window {
    dragMoveListener: any; // 👈️ turn off type checking
  }
}