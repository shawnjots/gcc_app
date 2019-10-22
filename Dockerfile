FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_11.x  | bash -
RUN apt-get -y install nodejs
RUN npm install
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["gcc_app.csproj", ""]
RUN dotnet restore "./gcc_app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "gcc_app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "gcc_app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "gcc_app.dll"]
