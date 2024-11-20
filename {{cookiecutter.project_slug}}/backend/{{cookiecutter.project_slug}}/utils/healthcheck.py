import logging

from django.http import HttpResponse, HttpResponseServerError

logger = logging.getLogger("healthz")


class HealthCheckMiddleware(object):
    def __init__(self, get_response):
        self.get_response = get_response
        # One-time configuration and initialization.

    def __call__(self, request):
        if request.method == "GET":
            if request.path == "/readiness":
                return self.readiness(request)
            elif request.path == "/healthz":
                return self.healthz(request)
        return self.get_response(request)

    def healthz(self, request):
        """
        Returns that the server is alive.
        """
        return HttpResponse("OK")

    def readiness(self, request):
        # Connect to each database and do a generic standard SQL query
        # that doesn't write any data and doesn't depend on any tables
        # being present.
        from django.db import connections

        for name in connections:
            cursor = None
            connection = connections[name]
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT 1;")
                row = cursor.fetchone()
                if row is None:
                    return HttpResponseServerError("db: invalid response")
            except Exception as e:
                logger.exception(e)
                return HttpResponseServerError("db: cannot connect to database.")
            finally:
                if cursor:
                    cursor.close()
                connection.close()

        # Call get_stats() to connect to each memcached instance and get its stats.
        # This can effectively check if each is online.
        try:
            from django.core.cache import caches
            from django.core.cache.backends.memcached import BaseMemcachedCache

            for cache in caches.all():
                if isinstance(cache, BaseMemcachedCache):
                    stats = cache._cache.get_stats()
                    if len(stats) != len(cache._servers):
                        return HttpResponseServerError(
                            "cache: cannot connect to cache."
                        )
        except Exception as e:
            logger.exception(e)
            return HttpResponseServerError("cache: cannot connect to cache.")

        return HttpResponse("OK")
