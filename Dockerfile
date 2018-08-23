FROM busybox AS base

FROM microsoft/dotnet:2.1-sdk AS publish
ARG project=bugRepro.csproj
WORKDIR /app
COPY ${project} .
RUN dotnet restore ${project} -r linux-x64
COPY . .
RUN dotnet publish ${project} --no-restore -c Release -r linux-x64 -o /app-publish

FROM base AS final
WORKDIR /app
COPY --from=publish /tests-publish .
ENTRYPOINT ["./bugRepro"]