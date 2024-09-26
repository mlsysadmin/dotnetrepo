# Use the official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the official .NET SDK as a parent image for build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["githubapp.csproj", "./"]
RUN dotnet restore "./githubapp.csproj"

# Copy the rest of the application code
COPY . .

# Build the app
RUN dotnet build "githubapp.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "githubapp.csproj" -c Release -o /app/publish

# Final image for running the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "githubapp.dll"]