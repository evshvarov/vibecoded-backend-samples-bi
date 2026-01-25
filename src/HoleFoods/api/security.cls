Class HoleFoods.api.security Extends %RegisteredObject
{

Parameter webapp = "/holefoods/api";

ClassMethod SetupSecurity() As %Status
{
    Set tSC = $$$OK
    Do ..IntroduceSQLRole()
    Do ..AddARole()
    Do ..AddCORS()
    Do ..IntroduceARoleDBUSER()
    Do ..AddARoleToUser()
    Quit tSC
}

ClassMethod IntroduceSQLRole() As %Status
{
    &SQL(CREATE ROLE holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error creating role: "_SQLCODE)
    }
    &SQL(GRANT SELECT,INSERT,UPDATE,DELETE on HoleFoods.Product to holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }
    &SQL(GRANT SELECT,INSERT,UPDATE,DELETE on HoleFoods.Country to holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }
    &SQL(GRANT SELECT,INSERT,UPDATE,DELETE on HoleFoods.Region to holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }
    &SQL(GRANT SELECT,INSERT,UPDATE,DELETE on HoleFoods.Outlet to holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }
    &SQL(GRANT SELECT,INSERT,UPDATE,DELETE on HoleFoods.SalesTransaction to holefoods)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }

    Quit $$$OK
}

ClassMethod IntroduceARoleDBUSER() As %Status
{
    &SQL(CREATE ROLE DB_USER_Read)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error creating role: "_SQLCODE)
    }

    New $NAMESPACE
    Set $NAMESPACE="%SYS"
    Set properties("Resources")="%DB_USER:R"

    Set sc = ##class(Security.Roles).Modify("DB_USER_Read", .properties)
    If $$$ISERR(sc) {
        Quit $$$ERROR($$$GeneralError, "Error modifying role: "_sc)
    }
    Quit sc
}

ClassMethod AddARoleToUser(user = "CSPSystem", ARole = "DB_USER_Read") As %Status
{
    New $NAMESPACE
    Set $NAMESPACE="%SYS"

    Set status=##class(Security.Users).Get(user, .MyUserProps)
    Set $p(MyUserProps("Roles"), ",", *)=ARole
    Set status=##class(Security.Users).Modify(user, .MyUserProps)

    If $$$ISOK(status) {
        Write !, "Roles for the user "_user_" were successfully modified."
    }
    Quit status
}

ClassMethod AddARole(appname, appARole = "holefoods") As %Status
{
    New $NAMESPACE
    Set $NAMESPACE="%SYS"

    Set appname = $g(appname, ..#webapp)

    Set status=##class(Security.Applications).Get(appname, .MyAppProps)
    Set MyAppProps("MatchRoles")=MyAppProps("MatchRoles")_":"_appARole

    Set status=##class(Security.Applications).Modify(appname, .MyAppProps)

    If $$$ISOK(status) {
        Write !, "Roles were successfully modified."
    }
    Quit status
}

ClassMethod AddCORS(appname) As %Status
{
    New $NAMESPACE
    Set $NAMESPACE="%SYS"
    Set appname = $g(appname, ..#webapp)

    Set status=##class(Security.Applications).Get(appname, .MyAppProps)
    Set MyAppProps("CorsAllowlist")="*"
    Set MyAppProps("CorsCredentialsAllowed")=1
    Set MyAppProps("CorsHeadersList")="Content-Type,Authorization,X-Requested-With,Accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers"
    Set status=##class(Security.Applications).Modify(appname, .MyAppProps)

    If $$$ISOK(status) {
        Write !, "CORS methods were successfully added to."_appname
    }
    Quit status
}

}
