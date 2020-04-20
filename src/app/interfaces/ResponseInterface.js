/**
 * @todo improve implementation
 */
class ResponseInterface {
    response = function(error = {}, data = {}) {
        if (error) {
            return {
                error: 1,
                code: 'listing_failed',
                description : 'Erro inesperado durante listagem',
                data: APP_DEBUG ? error : {}
            };
        }

        return {
            error: 0,
            code: 'data_found',
            description: 'dados encontrados',
            data: data
        };
    }
}

module.exports = ResponseInterface;