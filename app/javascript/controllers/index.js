import { application } from "controllers/application"

import AutoComplete from "./autocomplete_controller"

application.register("hello", AutoComplete)

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)