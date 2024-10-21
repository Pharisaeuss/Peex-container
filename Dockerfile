# Restore the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["SampleApp/SampleApp.csproj", "SampleApp/"]
RUN dotnet restore "SampleApp/SampleApp.csproj"

COPY . .

# Build the application
WORKDIR "/src/SampleApp"
RUN dotnet build "SampleApp.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "SampleApp.csproj" -c Release -o /app/publish 

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final-stage
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://0.0.0.0:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "SampleApp.dll"]
