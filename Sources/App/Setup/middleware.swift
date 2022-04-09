
import Vapor

/// Setup middlewares
func middlewares(_ app: Application) throws {
    
    // Remove all existing middleware.
    app.middleware = .init()
    
    /// setup CORS Middlewares
    app.middleware.use(CORSMiddleware())
    
    app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
    
    /// setup error Middleware
       app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
}
