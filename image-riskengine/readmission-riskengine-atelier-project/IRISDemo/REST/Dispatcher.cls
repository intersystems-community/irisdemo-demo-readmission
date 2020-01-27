Class IRISDemo.REST.Dispatcher Extends %CSP.REST
{
Parameter HandleCorsRequest = 1;

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";


XData UrlMap
{
  <Routes>
    <Map Prefix="/cube" Forward="IRISDemo.BS.CubeData.Service"/>
    <Map Prefix="/predict" Forward="ML.Model.BS.ExecutorService.Service"/>
  </Routes>
}
}