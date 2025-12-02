// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import SpotMetadataController from "./spot_metadata_controller"
application.register("spot-metadata", SpotMetadataController)
