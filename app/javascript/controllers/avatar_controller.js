import { Controller } from "@hotwired/stimulus";
const AvatarController = class extends Controller {
  // targets
  static targets = ["image", "fallback"];
  connect() {
    this.imageTarget.onerror = () => {
      if (this.hasFallbackTarget) {
        this.fallbackTarget.classList.remove("hidden");
      }
      this.imageTarget.classList.add("hidden");
    };
  }
};
export { AvatarController };
