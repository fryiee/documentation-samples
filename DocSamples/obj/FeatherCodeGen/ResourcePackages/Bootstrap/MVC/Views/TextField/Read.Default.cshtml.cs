#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SitefinityWebApp.ResourcePackages.Bootstrap.MVC.Views.TextField
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Text;
    using System.Web;
    using System.Web.Helpers;
    using System.Web.Mvc;
    using System.Web.Mvc.Ajax;
    using System.Web.Mvc.Html;
    using System.Web.Routing;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.WebPages;
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/MVC/Views/TextField/Read.Default.cshtml")]
    public partial class Read_Default : System.Web.Mvc.WebViewPage<Telerik.Sitefinity.Frontend.Forms.Mvc.Models.Fields.TextField.TextFieldViewModel>
    {
        public Read_Default()
        {
        }
        public override void Execute()
        {
WriteLiteral("<div");

WriteAttribute("class", Tuple.Create(" class=\"", 93), Tuple.Create("\"", 127)
            
            #line 3 "..\..MVC\Views\TextField\Read.Default.cshtml"
, Tuple.Create(Tuple.Create("", 101), Tuple.Create<System.Object, System.Int32>(Model.CssClass
            
            #line default
            #line hidden
, 101), false)
, Tuple.Create(Tuple.Create(" ", 116), Tuple.Create("form-group", 117), true)
);

WriteLiteral(" data-sf-role=\"text-field-container\"");

WriteLiteral(">\n    <strong>");

            
            #line 4 "..\..MVC\Views\TextField\Read.Default.cshtml"
       Write(Model.MetaField.Title);

            
            #line default
            #line hidden
WriteLiteral("</strong>\n    <p>");

            
            #line 5 "..\..MVC\Views\TextField\Read.Default.cshtml"
  Write(Model.Value);

            
            #line default
            #line hidden
WriteLiteral("</p>\n</div>\n");

        }
    }
}
#pragma warning restore 1591
