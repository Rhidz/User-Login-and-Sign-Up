import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    // MARK: ROUTE LOGIN
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    // MARK: ROUTE SIGN UP
    app.post("users") { req -> EventLoopFuture<User> in
        try User.Create.validate(content: req) // validata using User.Create
        let create = try req.content.decode(User.Create.self)
        
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passowrds don't match")
        }
        
        let user = try User(name: create.name, email: create.email, passwordHash: Bcrypt.hash(create.password))
        
        return user.save(on: req.db)
            .map { user }
        
    }
    // MARK: CURRENTLY AUTHENTICATED USER
    let tokenProtected = app.grouped(UserToken.authenticator())
    tokenProtected.get("me") { req -> User in
        try req.auth.require(User.self)
    }
    
    
}
