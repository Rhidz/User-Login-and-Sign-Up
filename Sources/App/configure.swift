import Vapor
import Fluent
import FluentSQLiteDriver



// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
    // MARK:- DATABASES
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
     
    // MARK:- REGISTER MIGRATIONS
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    try app.autoMigrate().wait()
    
    
    // MARK:- REGISTER APP ROUTES
    try routes(app)
}
