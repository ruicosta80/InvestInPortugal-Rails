// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo

console.log("Turbo loaded:", Turbo)

import "./controllers"
import * as bootstrap from "bootstrap"

// ActionText Dependencies (if you generated ActionText previously):
import "trix"
import "@rails/actiontext" 

// Active Storage Dependencies (if you generated Active Storage previously):
//import "activestorage"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()
