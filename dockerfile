# Copy Everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore "/App/App/DotNet.Docker.csproj"
# Build and publish a release
RUN dotnet publish "/App/App/DotNet.Docker.csproj" -c Release -r linux-x64 -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out
ENTRYPOINT ["dotnet","DotNet.Docker.dll"]