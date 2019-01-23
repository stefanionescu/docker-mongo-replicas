admin = db.getSiblingDB("admin")

admin.grantRolesToUser( "stefan", [ "root" , { role: "root", db: "admin" } ] )
