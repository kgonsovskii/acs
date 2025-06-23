using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Api;

/// <summary>
/// Запрос симулирирующий событие приложения ключа
/// </summary>
public class PassTouchedRequest : ProtoRequest
{
    /// <summary>
    /// Устройство
    /// </summary>
    public Guid SpotId { get; set; }

    /// <summary>
    /// Идентификатор ключа
    /// </summary>
    public string KeyNumber { get; set; }
}
