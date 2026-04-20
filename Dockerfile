# --- Build Stage ---
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy only the project file to cache NuGet layers
COPY ["dotapi.csproj", "./"]
RUN dotnet restore "dotapi.csproj"

# Copy everything else and publish
COPY . .
RUN dotnet publish "dotapi.csproj" -c Release -o /app/publish

# --- Runtime Stage ---
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# Expose the standard .NET container port
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "dotapi.dll"]